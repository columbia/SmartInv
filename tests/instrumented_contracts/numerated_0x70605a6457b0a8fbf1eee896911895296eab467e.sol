1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 // File: @openzeppelin/contracts/math/SafeMath.sol
80 
81 pragma solidity ^0.6.0;
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 pragma solidity ^0.6.2;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies in extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return _functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 // solhint-disable-next-line no-inline-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
382 
383 pragma solidity ^0.6.0;
384 
385 
386 
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using SafeMath for uint256;
399     using Address for address;
400 
401     function safeTransfer(IERC20 token, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
403     }
404 
405     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
406         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
407     }
408 
409     /**
410      * @dev Deprecated. This function has issues similar to the ones found in
411      * {IERC20-approve}, and its usage is discouraged.
412      *
413      * Whenever possible, use {safeIncreaseAllowance} and
414      * {safeDecreaseAllowance} instead.
415      */
416     function safeApprove(IERC20 token, address spender, uint256 value) internal {
417         // safeApprove should only be called when setting an initial allowance,
418         // or when resetting it to zero. To increase and decrease it, use
419         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
420         // solhint-disable-next-line max-line-length
421         require((value == 0) || (token.allowance(address(this), spender) == 0),
422             "SafeERC20: approve from non-zero to non-zero allowance"
423         );
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
425     }
426 
427     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
428         uint256 newAllowance = token.allowance(address(this), spender).add(value);
429         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
430     }
431 
432     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
433         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     /**
438      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
439      * on the return value: the return value is optional (but if data is returned, it must not be false).
440      * @param token The token targeted by the call.
441      * @param data The call data (encoded using abi.encode or one of its variants).
442      */
443     function _callOptionalReturn(IERC20 token, bytes memory data) private {
444         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
445         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
446         // the target address contains contract code and also asserts for success in the low-level call.
447 
448         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
449         if (returndata.length > 0) { // Return data is optional
450             // solhint-disable-next-line max-line-length
451             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/GSN/Context.sol
457 
458 pragma solidity ^0.6.0;
459 
460 /*
461  * @dev Provides information about the current execution context, including the
462  * sender of the transaction and its data. While these are generally available
463  * via msg.sender and msg.data, they should not be accessed in such a direct
464  * manner, since when dealing with GSN meta-transactions the account sending and
465  * paying for execution may not be the actual sender (as far as an application
466  * is concerned).
467  *
468  * This contract is only required for intermediate, library-like contracts.
469  */
470 abstract contract Context {
471     function _msgSender() internal view virtual returns (address payable) {
472         return msg.sender;
473     }
474 
475     function _msgData() internal view virtual returns (bytes memory) {
476         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
477         return msg.data;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
482 
483 // SPDX-License-Identifier: MIT
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
790 // File: contracts/ichiStake.sol
791 
792 pragma solidity 0.6.12;
793 
794 
795 
796 
797 // stake ICHI to earn more ICHI (from trading fees)
798 // This contract handles swapping to and from xIchi, IchiSwap's staking token.
799 contract IchiStake is ERC20("IchiStake", "xICHI") {
800     using SafeMath for uint256;
801     using SafeERC20 for IERC20;
802     address public Ichi;
803 
804     uint256 private constant DECIMALS = 9;
805 
806     // Define the Ichi token contract
807     constructor(address _Ichi) public {
808         _setupDecimals(uint8(DECIMALS));
809         Ichi = _Ichi;
810     }
811 
812     // Locks Ichi and mints xIchi (shares)
813     function enter(uint256 _amount) public {
814         uint256 totalIchiLocked = IERC20(Ichi).balanceOf(address(this));
815         uint256 totalShares = totalSupply(); // Gets the amount of xIchi in existence
816         
817         if (totalShares == 0 || totalIchiLocked == 0) { // If no xIchi exists, mint it 1:1 to the amount put in
818             _mint(msg.sender, _amount);
819         } else {
820             uint256 xIchiAmount = _amount.mul(totalShares).div(totalIchiLocked);
821             _mint(msg.sender, xIchiAmount);
822         }
823         // Lock the Ichi in the contract
824         IERC20(Ichi).transferFrom(msg.sender, address(this), _amount);
825     }
826 
827     // claim ICHI by burning xIchi
828     function leave(uint256 _share) public {
829         uint256 totalShares = totalSupply(); // Gets the amount of xIchi in existence
830 
831         uint256 ichiAmount = _share.mul(IERC20(Ichi).balanceOf(address(this))).div(totalShares);
832         _burn(msg.sender, _share);
833         IERC20(Ichi).transfer(msg.sender, ichiAmount);
834     }
835 }