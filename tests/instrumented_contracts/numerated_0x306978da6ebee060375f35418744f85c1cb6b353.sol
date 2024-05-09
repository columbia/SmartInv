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
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // This method relies in extcodesize, which returns 0 for contracts in
268         // construction, since the code is only stored at the end of the
269         // constructor execution.
270 
271         uint256 size;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { size := extcodesize(account) }
274         return size > 0;
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 pragma solidity ^0.6.0;
386 
387 
388 
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using SafeMath for uint256;
401     using Address for address;
402 
403     function safeTransfer(IERC20 token, address to, uint256 value) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
409     }
410 
411     /**
412      * @dev Deprecated. This function has issues similar to the ones found in
413      * {IERC20-approve}, and its usage is discouraged.
414      *
415      * Whenever possible, use {safeIncreaseAllowance} and
416      * {safeDecreaseAllowance} instead.
417      */
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
448         // the target address contains contract code and also asserts for success in the low-level call.
449 
450         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
451         if (returndata.length > 0) { // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
454         }
455     }
456 }
457 
458 // File: @openzeppelin/contracts/GSN/Context.sol
459 
460 pragma solidity ^0.6.0;
461 
462 /*
463  * @dev Provides information about the current execution context, including the
464  * sender of the transaction and its data. While these are generally available
465  * via msg.sender and msg.data, they should not be accessed in such a direct
466  * manner, since when dealing with GSN meta-transactions the account sending and
467  * paying for execution may not be the actual sender (as far as an application
468  * is concerned).
469  *
470  * This contract is only required for intermediate, library-like contracts.
471  */
472 abstract contract Context {
473     function _msgSender() internal view virtual returns (address payable) {
474         return msg.sender;
475     }
476 
477     function _msgData() internal view virtual returns (bytes memory) {
478         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
479         return msg.data;
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
484 
485 pragma solidity ^0.6.0;
486 
487 
488 
489 
490 
491 /**
492  * @dev Implementation of the {IERC20} interface.
493  *
494  * This implementation is agnostic to the way tokens are created. This means
495  * that a supply mechanism has to be added in a derived contract using {_mint}.
496  * For a generic mechanism see {ERC20PresetMinterPauser}.
497  *
498  * TIP: For a detailed writeup see our guide
499  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
500  * to implement supply mechanisms].
501  *
502  * We have followed general OpenZeppelin guidelines: functions revert instead
503  * of returning `false` on failure. This behavior is nonetheless conventional
504  * and does not conflict with the expectations of ERC20 applications.
505  *
506  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
507  * This allows applications to reconstruct the allowance for all accounts just
508  * by listening to said events. Other implementations of the EIP may not emit
509  * these events, as it isn't required by the specification.
510  *
511  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
512  * functions have been added to mitigate the well-known issues around setting
513  * allowances. See {IERC20-approve}.
514  */
515 contract ERC20 is Context, IERC20 {
516     using SafeMath for uint256;
517     using Address for address;
518 
519     mapping (address => uint256) private _balances;
520 
521     mapping (address => mapping (address => uint256)) private _allowances;
522 
523     uint256 private _totalSupply;
524 
525     string private _name;
526     string private _symbol;
527     uint8 private _decimals;
528 
529     /**
530      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
531      * a default value of 18.
532      *
533      * To select a different value for {decimals}, use {_setupDecimals}.
534      *
535      * All three of these values are immutable: they can only be set once during
536      * construction.
537      */
538     constructor (string memory name, string memory symbol) public {
539         _name = name;
540         _symbol = symbol;
541         _decimals = 18;
542     }
543 
544     /**
545      * @dev Returns the name of the token.
546      */
547     function name() public view returns (string memory) {
548         return _name;
549     }
550 
551     /**
552      * @dev Returns the symbol of the token, usually a shorter version of the
553      * name.
554      */
555     function symbol() public view returns (string memory) {
556         return _symbol;
557     }
558 
559     /**
560      * @dev Returns the number of decimals used to get its user representation.
561      * For example, if `decimals` equals `2`, a balance of `505` tokens should
562      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
563      *
564      * Tokens usually opt for a value of 18, imitating the relationship between
565      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
566      * called.
567      *
568      * NOTE: This information is only used for _display_ purposes: it in
569      * no way affects any of the arithmetic of the contract, including
570      * {IERC20-balanceOf} and {IERC20-transfer}.
571      */
572     function decimals() public view returns (uint8) {
573         return _decimals;
574     }
575 
576     /**
577      * @dev See {IERC20-totalSupply}.
578      */
579     function totalSupply() public view override returns (uint256) {
580         return _totalSupply;
581     }
582 
583     /**
584      * @dev See {IERC20-balanceOf}.
585      */
586     function balanceOf(address account) public view override returns (uint256) {
587         return _balances[account];
588     }
589 
590     /**
591      * @dev See {IERC20-transfer}.
592      *
593      * Requirements:
594      *
595      * - `recipient` cannot be the zero address.
596      * - the caller must have a balance of at least `amount`.
597      */
598     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
599         _transfer(_msgSender(), recipient, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-allowance}.
605      */
606     function allowance(address owner, address spender) public view virtual override returns (uint256) {
607         return _allowances[owner][spender];
608     }
609 
610     /**
611      * @dev See {IERC20-approve}.
612      *
613      * Requirements:
614      *
615      * - `spender` cannot be the zero address.
616      */
617     function approve(address spender, uint256 amount) public virtual override returns (bool) {
618         _approve(_msgSender(), spender, amount);
619         return true;
620     }
621 
622     /**
623      * @dev See {IERC20-transferFrom}.
624      *
625      * Emits an {Approval} event indicating the updated allowance. This is not
626      * required by the EIP. See the note at the beginning of {ERC20};
627      *
628      * Requirements:
629      * - `sender` and `recipient` cannot be the zero address.
630      * - `sender` must have a balance of at least `amount`.
631      * - the caller must have allowance for ``sender``'s tokens of at least
632      * `amount`.
633      */
634     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
635         _transfer(sender, recipient, amount);
636         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
637         return true;
638     }
639 
640     /**
641      * @dev Atomically increases the allowance granted to `spender` by the caller.
642      *
643      * This is an alternative to {approve} that can be used as a mitigation for
644      * problems described in {IERC20-approve}.
645      *
646      * Emits an {Approval} event indicating the updated allowance.
647      *
648      * Requirements:
649      *
650      * - `spender` cannot be the zero address.
651      */
652     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
653         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
654         return true;
655     }
656 
657     /**
658      * @dev Atomically decreases the allowance granted to `spender` by the caller.
659      *
660      * This is an alternative to {approve} that can be used as a mitigation for
661      * problems described in {IERC20-approve}.
662      *
663      * Emits an {Approval} event indicating the updated allowance.
664      *
665      * Requirements:
666      *
667      * - `spender` cannot be the zero address.
668      * - `spender` must have allowance for the caller of at least
669      * `subtractedValue`.
670      */
671     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
673         return true;
674     }
675 
676     /**
677      * @dev Moves tokens `amount` from `sender` to `recipient`.
678      *
679      * This is internal function is equivalent to {transfer}, and can be used to
680      * e.g. implement automatic token fees, slashing mechanisms, etc.
681      *
682      * Emits a {Transfer} event.
683      *
684      * Requirements:
685      *
686      * - `sender` cannot be the zero address.
687      * - `recipient` cannot be the zero address.
688      * - `sender` must have a balance of at least `amount`.
689      */
690     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
691         require(sender != address(0), "ERC20: transfer from the zero address");
692         require(recipient != address(0), "ERC20: transfer to the zero address");
693 
694         _beforeTokenTransfer(sender, recipient, amount);
695 
696         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
697         _balances[recipient] = _balances[recipient].add(amount);
698         emit Transfer(sender, recipient, amount);
699     }
700 
701     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
702      * the total supply.
703      *
704      * Emits a {Transfer} event with `from` set to the zero address.
705      *
706      * Requirements
707      *
708      * - `to` cannot be the zero address.
709      */
710     function _mint(address account, uint256 amount) internal virtual {
711         require(account != address(0), "ERC20: mint to the zero address");
712 
713         _beforeTokenTransfer(address(0), account, amount);
714 
715         _totalSupply = _totalSupply.add(amount);
716         _balances[account] = _balances[account].add(amount);
717         emit Transfer(address(0), account, amount);
718     }
719 
720     /**
721      * @dev Destroys `amount` tokens from `account`, reducing the
722      * total supply.
723      *
724      * Emits a {Transfer} event with `to` set to the zero address.
725      *
726      * Requirements
727      *
728      * - `account` cannot be the zero address.
729      * - `account` must have at least `amount` tokens.
730      */
731     function _burn(address account, uint256 amount) internal virtual {
732         require(account != address(0), "ERC20: burn from the zero address");
733 
734         _beforeTokenTransfer(account, address(0), amount);
735 
736         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
737         _totalSupply = _totalSupply.sub(amount);
738         emit Transfer(account, address(0), amount);
739     }
740 
741     /**
742      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
743      *
744      * This internal function is equivalent to `approve`, and can be used to
745      * e.g. set automatic allowances for certain subsystems, etc.
746      *
747      * Emits an {Approval} event.
748      *
749      * Requirements:
750      *
751      * - `owner` cannot be the zero address.
752      * - `spender` cannot be the zero address.
753      */
754     function _approve(address owner, address spender, uint256 amount) internal virtual {
755         require(owner != address(0), "ERC20: approve from the zero address");
756         require(spender != address(0), "ERC20: approve to the zero address");
757 
758         _allowances[owner][spender] = amount;
759         emit Approval(owner, spender, amount);
760     }
761 
762     /**
763      * @dev Sets {decimals} to a value other than the default one of 18.
764      *
765      * WARNING: This function should only be called from the constructor. Most
766      * applications that interact with token contracts will not expect
767      * {decimals} to ever change, and may work incorrectly if it does.
768      */
769     function _setupDecimals(uint8 decimals_) internal {
770         _decimals = decimals_;
771     }
772 
773     /**
774      * @dev Hook that is called before any transfer of tokens. This includes
775      * minting and burning.
776      *
777      * Calling conditions:
778      *
779      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
780      * will be to transferred to `to`.
781      * - when `from` is zero, `amount` tokens will be minted for `to`.
782      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
783      * - `from` and `to` are never both zero.
784      *
785      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
786      */
787     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
788 }
789 
790 // File: @openzeppelin/contracts/access/Ownable.sol
791 
792 pragma solidity ^0.6.0;
793 
794 /**
795  * @dev Contract module which provides a basic access control mechanism, where
796  * there is an account (an owner) that can be granted exclusive access to
797  * specific functions.
798  *
799  * By default, the owner account will be the one that deploys the contract. This
800  * can later be changed with {transferOwnership}.
801  *
802  * This module is used through inheritance. It will make available the modifier
803  * `onlyOwner`, which can be applied to your functions to restrict their use to
804  * the owner.
805  */
806 contract Ownable is Context {
807     address private _owner;
808 
809     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
810 
811     /**
812      * @dev Initializes the contract setting the deployer as the initial owner.
813      */
814     constructor () internal {
815         address msgSender = _msgSender();
816         _owner = msgSender;
817         emit OwnershipTransferred(address(0), msgSender);
818     }
819 
820     /**
821      * @dev Returns the address of the current owner.
822      */
823     function owner() public view returns (address) {
824         return _owner;
825     }
826 
827     /**
828      * @dev Throws if called by any account other than the owner.
829      */
830     modifier onlyOwner() {
831         require(_owner == _msgSender(), "Ownable: caller is not the owner");
832         _;
833     }
834 
835     /**
836      * @dev Leaves the contract without owner. It will not be possible to call
837      * `onlyOwner` functions anymore. Can only be called by the current owner.
838      *
839      * NOTE: Renouncing ownership will leave the contract without an owner,
840      * thereby removing any functionality that is only available to the owner.
841      */
842     function renounceOwnership() public virtual onlyOwner {
843         emit OwnershipTransferred(_owner, address(0));
844         _owner = address(0);
845     }
846 
847     /**
848      * @dev Transfers ownership of the contract to a new account (`newOwner`).
849      * Can only be called by the current owner.
850      */
851     function transferOwnership(address newOwner) public virtual onlyOwner {
852         require(newOwner != address(0), "Ownable: new owner is the zero address");
853         emit OwnershipTransferred(_owner, newOwner);
854         _owner = newOwner;
855     }
856 }
857 
858 // File: contracts/GDAOBar.sol
859 
860 pragma solidity 0.6.12;
861 
862 
863 
864 
865 
866 abstract contract GDAOBar is ERC20, Ownable{
867     using SafeERC20 for IERC20;
868     using SafeMath for uint256;
869     IERC20 public GDAO;
870 
871     uint256 public lockPeriod;
872 
873     // user address to last deposit timestamp mapping
874     mapping(address => uint256) public depositTimestamp;
875 
876 
877     constructor(address _gdao, uint _lockPeriod) public ERC20("GDAO governance","xGDAO") Ownable(){
878         GDAO = IERC20(_gdao);
879         lockPeriod = _lockPeriod;
880     }
881 
882     /// @dev update deposit lock period, only controller can call this function.
883     function updateLockPeriod(uint256 _newLockPeriod) external onlyOwner {
884         lockPeriod = _newLockPeriod;
885     }
886 
887     function enter(uint256 _amount) external virtual {
888         depositTimestamp[msg.sender] = block.timestamp;
889         // Gets the amount of GDAO locked in the contract
890         uint256 totalGDAO = GDAO.balanceOf(address(this));
891         // Gets the amount of GDAO in existence
892         uint256 totalShares = totalSupply();
893 
894         GDAO.transferFrom(msg.sender, address(this), _amount);
895         uint256 mintAmount = (totalShares == 0 || totalGDAO == 0) ? _amount :
896         _amount.mul(totalShares).div(totalGDAO);
897         _mint(msg.sender, mintAmount);
898 
899     }
900 
901     function leave(uint256 _share) external {
902         uint256 fee;
903         uint256 senderDepositTimestamp = depositTimestamp[msg.sender];
904         if(block.timestamp >= senderDepositTimestamp + lockPeriod){
905             uint dayCount = (block.timestamp - senderDepositTimestamp - lockPeriod) / 86400;
906             if(dayCount < 10){
907                 fee = 10 - dayCount;
908             }
909         }
910         // Calculates the amount of GDAO the xGDAO is worth
911         uint256 amm = getPrice(_share);
912         fee = _getWithdrawalFee(amm, fee);
913         _burn(msg.sender, _share);
914         GDAO.transfer(msg.sender, amm.sub(fee));
915     }
916 
917 
918     /// @dev function returns the ammount of xGDAO some _share of GDAO is worth
919     function getPrice(uint256 _share) public view returns(uint256){
920         if(totalSupply() > 0){
921             return _share.mul(GDAO.balanceOf(address(this))).div(totalSupply());
922         }else{
923             return 0;
924         }
925     }
926     
927     // @dev returns the withdrawalFee for a share
928     function _getWithdrawalFee(uint256 _share, uint256 _fee) internal pure returns(uint256){
929         return((_share.mul(_fee)).div(100));
930     }
931 }
932 
933 // File: contracts/PoolShareGovernanceToken.sol
934 
935 // From https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
936 
937 // Copyright 2020 Compound Labs, Inc.
938 // Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
939 // 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
940 // 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
941 // 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
942 // THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
943 
944 pragma solidity 0.6.12;
945 
946 
947 // solhint-disable reason-string, no-empty-blocks
948 abstract contract PoolShareGovernanceToken is GDAOBar {
949     /// @dev A record of each accounts delegate
950     mapping(address => address) public delegates;
951 
952     /// @dev A checkpoint for marking number of votes from a given block
953     struct Checkpoint {
954         uint32 fromBlock;
955         uint256 votes;
956     }
957 
958     /// @dev A record of votes checkpoints for each account, by index
959     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
960 
961     /// @dev The number of checkpoints for each account
962     mapping(address => uint32) public numCheckpoints;
963 
964     /// @dev The EIP-712 typehash for the delegation struct used by the contract
965     bytes32 public constant DELEGATION_TYPEHASH =
966         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
967 
968     /// @dev An event thats emitted when an account changes its delegate
969     event DelegateChanged(
970         address indexed delegator,
971         address indexed fromDelegate,
972         address indexed toDelegate
973     );
974 
975     /// @dev An event thats emitted when a delegate account's vote balance changes
976     event DelegateVotesChanged(
977         address indexed delegate,
978         uint256 previousBalance,
979         uint256 newBalance
980     );
981 
982     /**
983      * @dev Constructor.
984      */
985     constructor(
986         address _token, uint256 _lockPeriod
987     ) public GDAOBar(_token, _lockPeriod) {}
988 
989     /**
990      * @dev Delegate votes from `msg.sender` to `delegatee`
991      * @param delegatee The address to delegate votes to
992      */
993     function delegate(address delegatee) external {
994         return _delegate(msg.sender, delegatee);
995     }
996 
997     /**
998      * @dev Delegates votes from signatory to `delegatee`
999      * @param delegatee The address to delegate votes to
1000      * @param nonce The contract state required to match the signature
1001      * @param expiry The time at which to expire the signature
1002      * @param v The recovery byte of the signature
1003      * @param r Half of the ECDSA signature pair
1004      * @param s Half of the ECDSA signature pair
1005      */
1006     function delegateBySig(
1007         address delegatee,
1008         uint256 nonce,
1009         uint256 expiry,
1010         uint8 v,
1011         bytes32 r,
1012         bytes32 s
1013     ) external {
1014         bytes32 domainSeparator =
1015             keccak256(
1016                 abi.encode(
1017                     keccak256(bytes(name())),
1018                     keccak256(bytes("1")),
1019                     getChainId(),
1020                     address(this)
1021                 )
1022             );
1023 
1024         bytes32 structHash = keccak256(abi.encode(delegatee, nonce, expiry));
1025 
1026         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1027 
1028         address signatory = ecrecover(digest, v, r, s);
1029         require(signatory != address(0), "VSP::delegateBySig: invalid signature");
1030         require(now <= expiry, "VSP::delegateBySig: signature expired");
1031         return _delegate(signatory, delegatee);
1032     }
1033 
1034     /**
1035      * @dev Gets the current votes balance for `account`
1036      * @param account The address to get votes balance
1037      * @return The number of current votes for `account`
1038      */
1039     function getCurrentVotes(address account) external view returns (uint256) {
1040         uint32 nCheckpoints = numCheckpoints[account];
1041         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1042     }
1043 
1044     /**
1045      * @dev Determine the prior number of votes for an account as of a block number
1046      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1047      * @param account The address of the account to check
1048      * @param blockNumber The block number to get the vote balance at
1049      * @return The number of votes the account had as of the given block
1050      */
1051     function getPriorVotes(address account, uint256 blockNumber) external view returns (uint256) {
1052         require(blockNumber < block.number, "VSP::getPriorVotes: not yet determined");
1053 
1054         uint32 nCheckpoints = numCheckpoints[account];
1055         if (nCheckpoints == 0) {
1056             return 0;
1057         }
1058 
1059         // First check most recent balance
1060         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1061             return checkpoints[account][nCheckpoints - 1].votes;
1062         }
1063 
1064         // Next check implicit zero balance
1065         if (checkpoints[account][0].fromBlock > blockNumber) {
1066             return 0;
1067         }
1068 
1069         uint32 lower = 0;
1070         uint32 upper = nCheckpoints - 1;
1071         while (upper > lower) {
1072             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1073             Checkpoint memory cp = checkpoints[account][center];
1074             if (cp.fromBlock == blockNumber) {
1075                 return cp.votes;
1076             } else if (cp.fromBlock < blockNumber) {
1077                 lower = center;
1078             } else {
1079                 upper = center - 1;
1080             }
1081         }
1082         return checkpoints[account][lower].votes;
1083     }
1084 
1085     function _delegate(address delegator, address delegatee) internal {
1086         address currentDelegate = delegates[delegator];
1087         uint256 delegatorBalance = balanceOf(delegator);
1088         delegates[delegator] = delegatee;
1089 
1090         emit DelegateChanged(delegator, currentDelegate, delegatee);
1091 
1092         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1093     }
1094 
1095     function _moveDelegates(
1096         address srcRep,
1097         address dstRep,
1098         uint256 amount
1099     ) internal {
1100         if (srcRep != dstRep && amount > 0) {
1101             if (srcRep != address(0)) {
1102                 // decrease old representative
1103                 uint32 srcRepNum = numCheckpoints[srcRep];
1104                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1105                 uint256 srcRepNew = srcRepOld.sub(amount);
1106                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1107             }
1108 
1109             if (dstRep != address(0)) {
1110                 // increase new representative
1111                 uint32 dstRepNum = numCheckpoints[dstRep];
1112                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1113                 uint256 dstRepNew = dstRepOld.add(amount);
1114                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1115             }
1116         }
1117     }
1118 
1119     function _writeCheckpoint(
1120         address delegatee,
1121         uint32 nCheckpoints,
1122         uint256 oldVotes,
1123         uint256 newVotes
1124     ) internal {
1125         uint32 blockNumber =
1126             safe32(block.number, "VSP::_writeCheckpoint: block number exceeds 32 bits");
1127 
1128         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1129             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1130         } else {
1131             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1132             numCheckpoints[delegatee] = nCheckpoints + 1;
1133         }
1134 
1135         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1136     }
1137 
1138     function safe32(uint256 n, string memory errorMessage) internal pure returns (uint32) {
1139         require(n < 2**32, errorMessage);
1140         return uint32(n);
1141     }
1142 
1143     function getChainId() internal pure returns (uint256 chainId) {
1144         assembly {
1145             chainId := chainid()
1146         }
1147     }
1148 }
1149 
1150 // File: contracts/interfaces/uniswap/IUniswapV2Router01.sol
1151 
1152 pragma solidity 0.6.12;
1153 
1154 interface IUniswapV2Router01 {
1155     function factory() external pure returns (address);
1156 
1157     function swapExactTokensForTokens(
1158         uint256 amountIn,
1159         uint256 amountOutMin,
1160         address[] calldata path,
1161         address to,
1162         uint256 deadline
1163     ) external returns (uint256[] memory amounts);
1164 
1165     function swapTokensForExactTokens(
1166         uint256 amountOut,
1167         uint256 amountInMax,
1168         address[] calldata path,
1169         address to,
1170         uint256 deadline
1171     ) external returns (uint256[] memory amounts);
1172 
1173     function swapExactETHForTokens(
1174         uint256 amountOutMin,
1175         address[] calldata path,
1176         address to,
1177         uint256 deadline
1178     ) external payable returns (uint256[] memory amounts);
1179 
1180     function swapTokensForExactETH(
1181         uint256 amountOut,
1182         uint256 amountInMax,
1183         address[] calldata path,
1184         address to,
1185         uint256 deadline
1186     ) external returns (uint256[] memory amounts);
1187 
1188     function swapExactTokensForETH(
1189         uint256 amountIn,
1190         uint256 amountOutMin,
1191         address[] calldata path,
1192         address to,
1193         uint256 deadline
1194     ) external returns (uint256[] memory amounts);
1195 
1196     function swapETHForExactTokens(
1197         uint256 amountOut,
1198         address[] calldata path,
1199         address to,
1200         uint256 deadline
1201     ) external payable returns (uint256[] memory amounts);
1202 
1203     function quote(
1204         uint256 amountA,
1205         uint256 reserveA,
1206         uint256 reserveB
1207     ) external pure returns (uint256 amountB);
1208 
1209     function getAmountOut(
1210         uint256 amountIn,
1211         uint256 reserveIn,
1212         uint256 reserveOut
1213     ) external pure returns (uint256 amountOut);
1214 
1215     function getAmountIn(
1216         uint256 amountOut,
1217         uint256 reserveIn,
1218         uint256 reserveOut
1219     ) external pure returns (uint256 amountIn);
1220 
1221     function getAmountsOut(uint256 amountIn, address[] calldata path)
1222         external
1223         view
1224         returns (uint256[] memory amounts);
1225 
1226     function getAmountsIn(uint256 amountOut, address[] calldata path)
1227         external
1228         view
1229         returns (uint256[] memory amounts);
1230 }
1231 
1232 // File: contracts/interfaces/uniswap/IUniswapV2Router02.sol
1233 
1234 pragma solidity 0.6.12;
1235 
1236 
1237 interface IUniswapV2Router02 is IUniswapV2Router01 {
1238     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1239         uint256 amountIn,
1240         uint256 amountOutMin,
1241         address[] calldata path,
1242         address to,
1243         uint256 deadline
1244     ) external;
1245 
1246     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1247         uint256 amountOutMin,
1248         address[] calldata path,
1249         address to,
1250         uint256 deadline
1251     ) external payable;
1252 
1253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1254         uint256 amountIn,
1255         uint256 amountOutMin,
1256         address[] calldata path,
1257         address to,
1258         uint256 deadline
1259     ) external;
1260 }
1261 
1262 // File: address-list/contracts/interfaces/IAddressList.sol
1263 
1264 pragma solidity ^0.6.6;
1265 
1266 interface IAddressList {
1267     event AddressUpdated(address indexed a, address indexed sender);
1268     event AddressRemoved(address indexed a, address indexed sender);
1269 
1270     function add(address a) external returns (bool);
1271 
1272     function addValue(address a, uint256 v) external returns (bool);
1273 
1274     function addMulti(address[] calldata addrs) external returns (uint256);
1275 
1276     function addValueMulti(address[] calldata addrs, uint256[] calldata values) external returns (uint256);
1277 
1278     function remove(address a) external returns (bool);
1279 
1280     function removeMulti(address[] calldata addrs) external returns (uint256);
1281 
1282     function get(address a) external view returns (uint256);
1283 
1284     function contains(address a) external view returns (bool);
1285 
1286     function at(uint256 index) external view returns (address, uint256);
1287 
1288     function length() external view returns (uint256);
1289 }
1290 
1291 // File: contracts/interfaces/IController.sol
1292 
1293 pragma solidity 0.6.12;
1294 
1295 interface IController {
1296     function aaveReferralCode() external view returns (uint16);
1297 
1298     function feeCollector(address) external view returns (address);
1299 
1300     function founderFee() external view returns (uint256);
1301 
1302     function founderVault() external view returns (address);
1303 
1304     function interestFee(address) external view returns (uint256);
1305 
1306     function isPool(address) external view returns (bool);
1307 
1308     function pools() external view returns (address);
1309 
1310     function strategy(address) external view returns (address);
1311 
1312     function rebalanceFriction(address) external view returns (uint256);
1313 
1314     function poolRewards(address) external view returns (address);
1315 
1316     function treasuryPool() external view returns (address);
1317 
1318     function uniswapRouter() external view returns (address);
1319 
1320     function withdrawFee(address) external view returns (uint256);
1321 }
1322 
1323 // File: contracts/xGDAO.sol
1324 
1325 pragma solidity 0.6.12;
1326 
1327 
1328 
1329 
1330 interface IStrategy {
1331     function rebalance() external;
1332 }
1333 
1334 //solhint-disable no-empty-blocks, reason-string
1335 contract xGDAO is PoolShareGovernanceToken {
1336     uint256 internal constant MAX_UINT_VALUE = uint256(-1);
1337     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1338     address internal POE;
1339     uint8 public POE_TAX;
1340     IAddressList public immutable pools;
1341     IController public controller;
1342 
1343     constructor(address _controller, address _token, address _POE, uint8 _poeTax, uint256 _lockPeriod)
1344         public
1345         PoolShareGovernanceToken(_token, _lockPeriod)
1346     {
1347         controller = IController(_controller);
1348         pools = IAddressList(IController(_controller).pools());
1349         POE = _POE;
1350         setPoeTax(_poeTax);
1351     }
1352 
1353     modifier onlyController() {
1354         require(address(controller) == _msgSender(), "Caller is not the controller");
1355         _;
1356     }
1357 
1358     /// @dev Approve strategy for given pool
1359     function approvePool(address pool, address strategy) external onlyController {
1360         require(pools.contains(pool), "Not a pool");
1361         require(strategy == controller.strategy(address(this)), "Not a strategy");
1362         IERC20(pool).safeApprove(strategy, MAX_UINT_VALUE);
1363     }
1364 
1365     /**
1366      * @dev Controller will call this function when new strategy is added in pool.
1367      * Approve strategy for all tokens
1368      */
1369     function approveToken() external onlyController {
1370         _approve(MAX_UINT_VALUE);
1371     }
1372 
1373     /// @dev can set POE Tax
1374     function setPoeTax(uint8 _new) public onlyOwner(){
1375         require(_new <= 100, "Cannot set POE Tax > 100");
1376         POE_TAX = _new;
1377     }
1378 
1379     /// @dev set POE Contract address
1380     function setPOEContractAddress(address _new) external onlyOwner{
1381         POE = _new;
1382     }
1383 
1384     /// @dev override enter to tax 2% if user does not have a POE token.
1385     /// NOTE user must APPROVE this extra 2%, we can't just take it
1386     function enter(uint256 _amount) public override{
1387         depositTimestamp[msg.sender] = block.timestamp;
1388         // Gets the amount of GDAO locked in the contract
1389         uint256 totalGDAO = GDAO.balanceOf(address(this));
1390         // Gets the amount of GDAO in existence
1391         uint256 totalShares = totalSupply();
1392         // If no GDAO exists, mint it 1:1 to the amount put in
1393         if(totalGDAO > 0 && IERC20(POE).balanceOf(msg.sender) != 1){
1394             totalGDAO = (totalGDAO * (100 + POE_TAX)) / 100;
1395         }
1396 
1397         if (totalShares == 0 || totalGDAO == 0) {
1398             _mint(msg.sender, _amount);
1399         }
1400         
1401         else {
1402             uint256 what = _amount.mul(totalShares).div(totalGDAO);
1403             _mint(msg.sender, what);
1404         }
1405         GDAO.transferFrom(msg.sender, address(this), _amount);
1406     }
1407 
1408     /**
1409      * @dev Controller will call this function when strategy is removed from pool.
1410      * Reset approval of all tokens
1411      */
1412     function resetApproval() external onlyController {
1413         _approve(uint256(0));
1414     }
1415 
1416     function rebalance() external {
1417         IStrategy strategy = IStrategy(controller.strategy(address(this)));
1418         strategy.rebalance();
1419     }
1420 
1421     function sweepErc20(address _erc20) external {
1422         require(
1423             _erc20 != address(GDAO) && _erc20 != address(this) && !controller.isPool(_erc20),
1424             "Not allowed to sweep"
1425         );
1426         IUniswapV2Router02 uniswapRouter = IUniswapV2Router02(controller.uniswapRouter());
1427         IERC20 erc20 = IERC20(_erc20);
1428         uint256 amt = erc20.balanceOf(address(this));
1429         erc20.safeApprove(address(uniswapRouter), 0);
1430         erc20.safeApprove(address(uniswapRouter), amt);
1431         address[] memory path;
1432         if (address(_erc20) == WETH) {
1433             path = new address[](2);
1434             path[0] = address(_erc20);
1435             path[1] = address(GDAO);
1436         } else {
1437             path = new address[](3);
1438             path[0] = address(_erc20);
1439             path[1] = address(WETH);
1440             path[2] = address(GDAO);
1441         }
1442         uniswapRouter.swapExactTokensForTokens(amt, 1, path, address(this), now + 30);
1443     }
1444 
1445     function changeController(address _newController) external onlyOwner{
1446         controller = IController(_newController);
1447     }
1448 
1449     function _beforeTokenTransfer(
1450         address from,
1451         address to,
1452         uint256 amount
1453     ) internal override {
1454         if (from == address(0)) {
1455             // Token being minted i.e. user is depositing VSP
1456             // NOTE: here 'to' is same as 'msg.sender'
1457             depositTimestamp[to] = block.timestamp;
1458         } else {
1459             // transfer, transferFrom or withdraw is called.
1460             require(
1461                 block.timestamp >= depositTimestamp[from].add(lockPeriod),
1462                 "Operation not allowed due to lock period"
1463             );
1464         }
1465         // Move vVSP delegation when mint, burn, transfer or transferFrom is called.
1466         _moveDelegates(delegates[from], delegates[to], amount);
1467     }
1468 
1469     function _approve(uint256 approvalAmount) private {
1470         address strategy = controller.strategy(address(this));
1471         uint256 length = pools.length();
1472         for (uint256 i = 0; i < length; i++) {
1473             (address pool, ) = pools.at(i);
1474             IERC20(pool).safeApprove(strategy, approvalAmount);
1475         }
1476     }
1477 }