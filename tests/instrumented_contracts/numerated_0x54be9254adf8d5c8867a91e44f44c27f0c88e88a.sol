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
245 
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
389 
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
466 
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
491 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
492 
493 
494 
495 pragma solidity ^0.6.0;
496 
497 
498 
499 
500 
501 /**
502  * @dev Implementation of the {IERC20} interface.
503  *
504  * This implementation is agnostic to the way tokens are created. This means
505  * that a supply mechanism has to be added in a derived contract using {_mint}.
506  * For a generic mechanism see {ERC20PresetMinterPauser}.
507  *
508  * TIP: For a detailed writeup see our guide
509  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
510  * to implement supply mechanisms].
511  *
512  * We have followed general OpenZeppelin guidelines: functions revert instead
513  * of returning `false` on failure. This behavior is nonetheless conventional
514  * and does not conflict with the expectations of ERC20 applications.
515  *
516  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
517  * This allows applications to reconstruct the allowance for all accounts just
518  * by listening to said events. Other implementations of the EIP may not emit
519  * these events, as it isn't required by the specification.
520  *
521  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
522  * functions have been added to mitigate the well-known issues around setting
523  * allowances. See {IERC20-approve}.
524  */
525 contract ERC20 is Context, IERC20 {
526     using SafeMath for uint256;
527     using Address for address;
528 
529     mapping (address => uint256) private _balances;
530 
531     mapping (address => mapping (address => uint256)) private _allowances;
532 
533     uint256 private _totalSupply;
534 
535     string private _name;
536     string private _symbol;
537     uint8 private _decimals;
538 
539     /**
540      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
541      * a default value of 18.
542      *
543      * To select a different value for {decimals}, use {_setupDecimals}.
544      *
545      * All three of these values are immutable: they can only be set once during
546      * construction.
547      */
548     constructor (string memory name, string memory symbol) public {
549         _name = name;
550         _symbol = symbol;
551         _decimals = 18;
552     }
553 
554     /**
555      * @dev Returns the name of the token.
556      */
557     function name() public view returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev Returns the symbol of the token, usually a shorter version of the
563      * name.
564      */
565     function symbol() public view returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the number of decimals used to get its user representation.
571      * For example, if `decimals` equals `2`, a balance of `505` tokens should
572      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573      *
574      * Tokens usually opt for a value of 18, imitating the relationship between
575      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
576      * called.
577      *
578      * NOTE: This information is only used for _display_ purposes: it in
579      * no way affects any of the arithmetic of the contract, including
580      * {IERC20-balanceOf} and {IERC20-transfer}.
581      */
582     function decimals() public view returns (uint8) {
583         return _decimals;
584     }
585 
586     /**
587      * @dev See {IERC20-totalSupply}.
588      */
589     function totalSupply() public view override returns (uint256) {
590         return _totalSupply;
591     }
592 
593     /**
594      * @dev See {IERC20-balanceOf}.
595      */
596     function balanceOf(address account) public view override returns (uint256) {
597         return _balances[account];
598     }
599 
600     /**
601      * @dev See {IERC20-transfer}.
602      *
603      * Requirements:
604      *
605      * - `recipient` cannot be the zero address.
606      * - the caller must have a balance of at least `amount`.
607      */
608     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
609         _transfer(_msgSender(), recipient, amount);
610         return true;
611     }
612 
613     /**
614      * @dev See {IERC20-allowance}.
615      */
616     function allowance(address owner, address spender) public view virtual override returns (uint256) {
617         return _allowances[owner][spender];
618     }
619 
620     /**
621      * @dev See {IERC20-approve}.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function approve(address spender, uint256 amount) public virtual override returns (bool) {
628         _approve(_msgSender(), spender, amount);
629         return true;
630     }
631 
632     /**
633      * @dev See {IERC20-transferFrom}.
634      *
635      * Emits an {Approval} event indicating the updated allowance. This is not
636      * required by the EIP. See the note at the beginning of {ERC20};
637      *
638      * Requirements:
639      * - `sender` and `recipient` cannot be the zero address.
640      * - `sender` must have a balance of at least `amount`.
641      * - the caller must have allowance for ``sender``'s tokens of at least
642      * `amount`.
643      */
644     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
645         _transfer(sender, recipient, amount);
646         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
647         return true;
648     }
649 
650     /**
651      * @dev Atomically increases the allowance granted to `spender` by the caller.
652      *
653      * This is an alternative to {approve} that can be used as a mitigation for
654      * problems described in {IERC20-approve}.
655      *
656      * Emits an {Approval} event indicating the updated allowance.
657      *
658      * Requirements:
659      *
660      * - `spender` cannot be the zero address.
661      */
662     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
663         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
664         return true;
665     }
666 
667     /**
668      * @dev Atomically decreases the allowance granted to `spender` by the caller.
669      *
670      * This is an alternative to {approve} that can be used as a mitigation for
671      * problems described in {IERC20-approve}.
672      *
673      * Emits an {Approval} event indicating the updated allowance.
674      *
675      * Requirements:
676      *
677      * - `spender` cannot be the zero address.
678      * - `spender` must have allowance for the caller of at least
679      * `subtractedValue`.
680      */
681     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
682         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
683         return true;
684     }
685 
686     /**
687      * @dev Moves tokens `amount` from `sender` to `recipient`.
688      *
689      * This is internal function is equivalent to {transfer}, and can be used to
690      * e.g. implement automatic token fees, slashing mechanisms, etc.
691      *
692      * Emits a {Transfer} event.
693      *
694      * Requirements:
695      *
696      * - `sender` cannot be the zero address.
697      * - `recipient` cannot be the zero address.
698      * - `sender` must have a balance of at least `amount`.
699      */
700     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
701         require(sender != address(0), "ERC20: transfer from the zero address");
702         require(recipient != address(0), "ERC20: transfer to the zero address");
703 
704         _beforeTokenTransfer(sender, recipient, amount);
705 
706         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
707         _balances[recipient] = _balances[recipient].add(amount);
708         emit Transfer(sender, recipient, amount);
709     }
710 
711     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
712      * the total supply.
713      *
714      * Emits a {Transfer} event with `from` set to the zero address.
715      *
716      * Requirements
717      *
718      * - `to` cannot be the zero address.
719      */
720     function _mint(address account, uint256 amount) internal virtual {
721         require(account != address(0), "ERC20: mint to the zero address");
722 
723         _beforeTokenTransfer(address(0), account, amount);
724 
725         _totalSupply = _totalSupply.add(amount);
726         _balances[account] = _balances[account].add(amount);
727         emit Transfer(address(0), account, amount);
728     }
729 
730     /**
731      * @dev Destroys `amount` tokens from `account`, reducing the
732      * total supply.
733      *
734      * Emits a {Transfer} event with `to` set to the zero address.
735      *
736      * Requirements
737      *
738      * - `account` cannot be the zero address.
739      * - `account` must have at least `amount` tokens.
740      */
741     function _burn(address account, uint256 amount) internal virtual {
742         require(account != address(0), "ERC20: burn from the zero address");
743 
744         _beforeTokenTransfer(account, address(0), amount);
745 
746         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
747         _totalSupply = _totalSupply.sub(amount);
748         emit Transfer(account, address(0), amount);
749     }
750 
751     /**
752      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
753      *
754      * This internal function is equivalent to `approve`, and can be used to
755      * e.g. set automatic allowances for certain subsystems, etc.
756      *
757      * Emits an {Approval} event.
758      *
759      * Requirements:
760      *
761      * - `owner` cannot be the zero address.
762      * - `spender` cannot be the zero address.
763      */
764     function _approve(address owner, address spender, uint256 amount) internal virtual {
765         require(owner != address(0), "ERC20: approve from the zero address");
766         require(spender != address(0), "ERC20: approve to the zero address");
767 
768         _allowances[owner][spender] = amount;
769         emit Approval(owner, spender, amount);
770     }
771 
772     /**
773      * @dev Sets {decimals} to a value other than the default one of 18.
774      *
775      * WARNING: This function should only be called from the constructor. Most
776      * applications that interact with token contracts will not expect
777      * {decimals} to ever change, and may work incorrectly if it does.
778      */
779     function _setupDecimals(uint8 decimals_) internal {
780         _decimals = decimals_;
781     }
782 
783     /**
784      * @dev Hook that is called before any transfer of tokens. This includes
785      * minting and burning.
786      *
787      * Calling conditions:
788      *
789      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
790      * will be to transferred to `to`.
791      * - when `from` is zero, `amount` tokens will be minted for `to`.
792      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
793      * - `from` and `to` are never both zero.
794      *
795      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
796      */
797     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
798 }
799 
800 // File: contracts/interfaces/flamincome/Controller.sol
801 
802 
803 pragma solidity ^0.6.2;
804 
805 interface Controller {
806     function strategist() external view returns (address);
807     function vaults(address) external view returns (address);
808     function rewards() external view returns (address);
809     function balanceOf(address) external view returns (uint);
810     function withdraw(address, uint) external;
811     function earn(address, uint) external;
812 }
813 
814 // File: contracts/implementations/vault/VaultBaseline.sol
815 
816 
817 pragma solidity ^0.6.2;
818 
819 
820 
821 
822 
823 
824 
825 
826 contract VaultBaseline is ERC20 {
827     using SafeERC20 for IERC20;
828     using Address for address;
829     using SafeMath for uint256;
830 
831     IERC20 public token;
832 
833     uint public min = 9500;
834     uint public constant max = 10000;
835 
836     address public governance;
837     address public controller;
838 
839     constructor (address _token, address _controller) public ERC20(
840         string(abi.encodePacked("flamincomed ", ERC20(_token).name())),
841         string(abi.encodePacked("f", ERC20(_token).symbol()))
842     ) {
843         _setupDecimals(ERC20(_token).decimals());
844         token = IERC20(_token);
845         governance = msg.sender;
846         controller = _controller;
847     }
848 
849     function balance() public view returns (uint) {
850         return token.balanceOf(address(this))
851                 .add(Controller(controller).balanceOf(address(token)));
852     }
853 
854     function setMin(uint _min) external {
855         require(msg.sender == governance, "!governance");
856         min = _min;
857     }
858 
859     function setGovernance(address _governance) public {
860         require(msg.sender == governance, "!governance");
861         governance = _governance;
862     }
863 
864     function setController(address _controller) public {
865         require(msg.sender == governance, "!governance");
866         controller = _controller;
867     }
868 
869     // Custom logic in here for how much the vault allows to be borrowed
870     // Sets minimum required on-hand to keep small withdrawals cheap
871     function available() public view returns (uint) {
872         return token.balanceOf(address(this)).mul(min).div(max);
873     }
874 
875     function earn() public {
876         uint _bal = available();
877         token.safeTransfer(controller, _bal);
878         Controller(controller).earn(address(token), _bal);
879     }
880 
881     function depositAll() external {
882         deposit(token.balanceOf(msg.sender));
883     }
884 
885     function deposit(uint _amount) public {
886         uint _pool = balance();
887         uint _before = token.balanceOf(address(this));
888         token.safeTransferFrom(msg.sender, address(this), _amount);
889         uint _after = token.balanceOf(address(this));
890         _amount = _after.sub(_before); // Additional check for deflationary tokens
891         uint shares = 0;
892         if (totalSupply() == 0) {
893             shares = _amount;
894         } else {
895             shares = (_amount.mul(totalSupply())).div(_pool);
896         }
897         _mint(msg.sender, shares);
898     }
899 
900     function withdrawAll() external {
901         withdraw(balanceOf(msg.sender));
902     }
903 
904 
905     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
906     function harvest(address reserve, uint amount) external {
907         require(msg.sender == controller, "!controller");
908         require(reserve != address(token), "token");
909         IERC20(reserve).safeTransfer(controller, amount);
910     }
911 
912     // No rebalance implementation for lower fees and faster swaps
913     function withdraw(uint _shares) public {
914         uint r = (balance().mul(_shares)).div(totalSupply());
915         _burn(msg.sender, _shares);
916 
917         // Check balance
918         uint b = token.balanceOf(address(this));
919         if (b < r) {
920             uint _withdraw = r.sub(b);
921             Controller(controller).withdraw(address(token), _withdraw);
922             uint _after = token.balanceOf(address(this));
923             uint _diff = _after.sub(b);
924             if (_diff < _withdraw) {
925                 r = b.add(_diff);
926             }
927         }
928 
929         token.safeTransfer(msg.sender, r);
930     }
931 
932     function priceE18() public view returns (uint) {
933         return balance().mul(1e18).div(totalSupply());
934     }
935 }
936 
937 // File: contracts/instances/VaultBaselineUSDT.sol
938 
939 
940 pragma solidity ^0.6.2;
941 
942 
943 contract VaultBaselineUSDT is VaultBaseline {
944     constructor()
945         public
946         VaultBaseline(
947             address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
948             address(0xDc03b4900Eff97d997f4B828ae0a45cd48C3b22d)
949         )
950     {}
951 }