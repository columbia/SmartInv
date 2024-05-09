1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/SafeERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 
8 
9 
10 /**
11  * @title SafeERC20
12  * @dev Wrappers around ERC20 operations that throw on failure (when the token
13  * contract returns false). Tokens that return no value (and instead revert or
14  * throw on failure) are also supported, non-reverting calls are assumed to be
15  * successful.
16  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
17  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
18  */
19 library SafeERC20 {
20     using SafeMath for uint256;
21     using Address for address;
22 
23     function safeTransfer(IERC20 token, address to, uint256 value) internal {
24         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
25     }
26 
27     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
28         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
29     }
30 
31     /**
32      * @dev Deprecated. This function has issues similar to the ones found in
33      * {IERC20-approve}, and its usage is discouraged.
34      *
35      * Whenever possible, use {safeIncreaseAllowance} and
36      * {safeDecreaseAllowance} instead.
37      */
38     function safeApprove(IERC20 token, address spender, uint256 value) internal {
39         // safeApprove should only be called when setting an initial allowance,
40         // or when resetting it to zero. To increase and decrease it, use
41         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
42         // solhint-disable-next-line max-line-length
43         require((value == 0) || (token.allowance(address(this), spender) == 0),
44             "SafeERC20: approve from non-zero to non-zero allowance"
45         );
46         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
47     }
48 
49     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
50         uint256 newAllowance = token.allowance(address(this), spender).add(value);
51         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
52     }
53 
54     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
55         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
56         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
57     }
58 
59     /**
60      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
61      * on the return value: the return value is optional (but if data is returned, it must not be false).
62      * @param token The token targeted by the call.
63      * @param data The call data (encoded using abi.encode or one of its variants).
64      */
65     function _callOptionalReturn(IERC20 token, bytes memory data) private {
66         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
67         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
68         // the target address contains contract code and also asserts for success in the low-level call.
69 
70         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
71         if (returndata.length > 0) { // Return data is optional
72             // solhint-disable-next-line max-line-length
73             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
74         }
75     }
76 }
77 
78 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/Address.sol
79 
80 // SPDX-License-Identifier: MIT
81 
82 pragma solidity ^0.6.2;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize, which returns 0 for contracts in
107         // construction, since the code is only stored at the end of the
108         // constructor execution.
109 
110         uint256 size;
111         // solhint-disable-next-line no-inline-assembly
112         assembly { size := extcodesize(account) }
113         return size > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
136         (bool success, ) = recipient.call{ value: amount }("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain`call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159       return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
169         return _functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         return _functionCallWithValue(target, data, value, errorMessage);
196     }
197 
198     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 // solhint-disable-next-line no-inline-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/math/SafeMath.sol
223 
224 // SPDX-License-Identifier: MIT
225 
226 pragma solidity ^0.6.0;
227 
228 /**
229  * @dev Wrappers over Solidity's arithmetic operations with added overflow
230  * checks.
231  *
232  * Arithmetic operations in Solidity wrap on overflow. This can easily result
233  * in bugs, because programmers usually assume that an overflow raises an
234  * error, which is the standard behavior in high level programming languages.
235  * `SafeMath` restores this intuition by reverting the transaction when an
236  * operation overflows.
237  *
238  * Using this library instead of the unchecked operations eliminates an entire
239  * class of bugs, so it's recommended to use it always.
240  */
241 library SafeMath {
242     /**
243      * @dev Returns the addition of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `+` operator.
247      *
248      * Requirements:
249      *
250      * - Addition cannot overflow.
251      */
252     function add(uint256 a, uint256 b) internal pure returns (uint256) {
253         uint256 c = a + b;
254         require(c >= a, "SafeMath: addition overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         return sub(a, b, "SafeMath: subtraction overflow");
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
275      * overflow (when the result is negative).
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b <= a, errorMessage);
285         uint256 c = a - b;
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the multiplication of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `*` operator.
295      *
296      * Requirements:
297      *
298      * - Multiplication cannot overflow.
299      */
300     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
301         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
302         // benefit is lost if 'b' is also tested.
303         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
304         if (a == 0) {
305             return 0;
306         }
307 
308         uint256 c = a * b;
309         require(c / a == b, "SafeMath: multiplication overflow");
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the integer division of two unsigned integers. Reverts on
316      * division by zero. The result is rounded towards zero.
317      *
318      * Counterpart to Solidity's `/` operator. Note: this function uses a
319      * `revert` opcode (which leaves remaining gas untouched) while Solidity
320      * uses an invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function div(uint256 a, uint256 b) internal pure returns (uint256) {
327         return div(a, b, "SafeMath: division by zero");
328     }
329 
330     /**
331      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
332      * division by zero. The result is rounded towards zero.
333      *
334      * Counterpart to Solidity's `/` operator. Note: this function uses a
335      * `revert` opcode (which leaves remaining gas untouched) while Solidity
336      * uses an invalid opcode to revert (consuming all remaining gas).
337      *
338      * Requirements:
339      *
340      * - The divisor cannot be zero.
341      */
342     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b > 0, errorMessage);
344         uint256 c = a / b;
345         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
346 
347         return c;
348     }
349 
350     /**
351      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
352      * Reverts when dividing by zero.
353      *
354      * Counterpart to Solidity's `%` operator. This function uses a `revert`
355      * opcode (which leaves remaining gas untouched) while Solidity uses an
356      * invalid opcode to revert (consuming all remaining gas).
357      *
358      * Requirements:
359      *
360      * - The divisor cannot be zero.
361      */
362     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
363         return mod(a, b, "SafeMath: modulo by zero");
364     }
365 
366     /**
367      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
368      * Reverts with custom message when dividing by zero.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
379         require(b != 0, errorMessage);
380         return a % b;
381     }
382 }
383 
384 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
385 
386 // SPDX-License-Identifier: MIT
387 
388 pragma solidity ^0.6.0;
389 
390 /**
391  * @dev Interface of the ERC20 standard as defined in the EIP.
392  */
393 interface IERC20 {
394     /**
395      * @dev Returns the amount of tokens in existence.
396      */
397     function totalSupply() external view returns (uint256);
398 
399     /**
400      * @dev Returns the amount of tokens owned by `account`.
401      */
402     function balanceOf(address account) external view returns (uint256);
403 
404     /**
405      * @dev Moves `amount` tokens from the caller's account to `recipient`.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transfer(address recipient, uint256 amount) external returns (bool);
412 
413     /**
414      * @dev Returns the remaining number of tokens that `spender` will be
415      * allowed to spend on behalf of `owner` through {transferFrom}. This is
416      * zero by default.
417      *
418      * This value changes when {approve} or {transferFrom} are called.
419      */
420     function allowance(address owner, address spender) external view returns (uint256);
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
424      *
425      * Returns a boolean value indicating whether the operation succeeded.
426      *
427      * IMPORTANT: Beware that changing an allowance with this method brings the risk
428      * that someone may use both the old and the new allowance by unfortunate
429      * transaction ordering. One possible solution to mitigate this race
430      * condition is to first reduce the spender's allowance to 0 and set the
431      * desired value afterwards:
432      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
433      *
434      * Emits an {Approval} event.
435      */
436     function approve(address spender, uint256 amount) external returns (bool);
437 
438     /**
439      * @dev Moves `amount` tokens from `sender` to `recipient` using the
440      * allowance mechanism. `amount` is then deducted from the caller's
441      * allowance.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
448 
449     /**
450      * @dev Emitted when `value` tokens are moved from one account (`from`) to
451      * another (`to`).
452      *
453      * Note that `value` may be zero.
454      */
455     event Transfer(address indexed from, address indexed to, uint256 value);
456 
457     /**
458      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
459      * a call to {approve}. `value` is the new allowance.
460      */
461     event Approval(address indexed owner, address indexed spender, uint256 value);
462 }
463 
464 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/GSN/Context.sol
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
491 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
492 
493 // SPDX-License-Identifier: MIT
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
800 // File: browser/DarkNyan.sol
801 
802 pragma solidity ^0.6.6;
803 
804 
805 
806 
807 contract DarkNyan is ERC20{
808     
809     using SafeERC20 for IERC20;
810     using SafeMath for uint256;
811 
812 
813     struct stakeTracker {
814         uint256 lastBlockChecked;
815         uint256 rewards;
816         uint256 catnipPoolTokens;
817         uint256 darkNyanPoolTokens;
818     }
819     
820     mapping(address => stakeTracker) private stakedBalances;
821 
822 
823     address owner;
824     
825     address public fundVotingAddress;
826     
827     bool public isSendingFunds = false;
828     
829     uint256 private lastBlockSent;
830     
831     uint256 public liquidityMultiplier = 70;
832     uint256 public miningDifficulty = 40000;
833     
834     IERC20 private catnip;
835     IERC20 private darkNyan;
836     
837     IERC20 private catnipV2;
838     address public catnipUniswapV2Pair;
839     
840     IERC20 private darkNyanV2;
841     address public darkNyanUniswapV2Pair;
842     
843     uint256 totalLiquidityStaked;
844 
845 
846     modifier _onlyOwner() {
847         require(msg.sender == owner);
848         _;
849     }
850     
851     modifier updateStakingReward(address _account) {
852         uint256 liquidityBonus;
853         if (stakedBalances[_account].darkNyanPoolTokens > 0) {
854             liquidityBonus = stakedBalances[_account].darkNyanPoolTokens/ liquidityMultiplier;
855         }
856         if (block.number > stakedBalances[_account].lastBlockChecked) {
857             uint256 rewardBlocks = block.number
858                                         .sub(stakedBalances[_account].lastBlockChecked);
859                                         
860                                         
861              
862             if (stakedBalances[_account].catnipPoolTokens > 0) {
863                 stakedBalances[_account].rewards = stakedBalances[_account].rewards
864                                                                             .add(stakedBalances[_account].catnipPoolTokens)
865                                                                             .add(liquidityBonus)
866                                                                             .mul(rewardBlocks)
867                                                                             / miningDifficulty;
868             }
869             
870            
871                     
872             stakedBalances[_account].lastBlockChecked = block.number;
873             
874             
875             emit Rewards(_account, stakedBalances[_account].rewards);                                                     
876         }
877         _;
878     }
879     
880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
881     
882     event catnipUniStaked(address indexed user, uint256 amount, uint256 totalLiquidityStaked);
883     
884     event darkNyanUniStaked(address indexed user, uint256 amount, uint256 totalLiquidityStaked);
885     
886     event catnipUniWithdrawn(address indexed user, uint256 amount, uint256 totalLiquidityStaked);
887     
888     event darkNyanUniWithdrawn(address indexed user, uint256 amount, uint256 totalLiquidityStaked);
889     
890     event Rewards(address indexed user, uint256 reward);
891     
892     event FundsSentToFundingAddress(address indexed user, uint256 amount);
893     
894     event votingAddressChanged(address indexed user, address votingAddress);
895     
896     event catnipPairAddressChanged(address indexed user, address catnipPairAddress);
897     
898     event darkNyanPairAddressChanged(address indexed user, address darkNyanPairAddress);
899     
900     event difficultyChanged(address indexed user, uint256 difficulty);
901 
902 
903     constructor() public payable ERC20("darkNYAN", "dNYAN") {
904         owner = msg.sender;
905         uint256 supply = 100;
906         _mint(msg.sender, supply.mul(10 ** 18));
907         lastBlockSent = block.number;
908     }
909     
910     function transferOwnership(address newOwner) external _onlyOwner {
911         assert(newOwner != address(0)/*, "Ownable: new owner is the zero address"*/);
912         emit OwnershipTransferred(owner, newOwner);
913         owner = newOwner;
914     }
915     
916     function setVotingAddress(address _account) public _onlyOwner {
917         fundVotingAddress = _account;
918         emit votingAddressChanged(msg.sender, fundVotingAddress);
919     }
920     
921     function setCatnipPairAddress(address _uniV2address) public _onlyOwner {
922         catnipUniswapV2Pair = _uniV2address;
923         catnipV2 = IERC20(catnipUniswapV2Pair);
924         emit catnipPairAddressChanged(msg.sender, catnipUniswapV2Pair);
925     }
926 
927     function setdarkNyanPairAddress(address _uniV2address) public _onlyOwner {
928         darkNyanUniswapV2Pair = _uniV2address;
929         darkNyanV2 = IERC20(darkNyanUniswapV2Pair);
930         emit darkNyanPairAddressChanged(msg.sender, darkNyanUniswapV2Pair);
931     }
932     
933      function setMiningDifficulty(uint256 amount) public _onlyOwner {
934        miningDifficulty = amount;
935        emit difficultyChanged(msg.sender, miningDifficulty);
936    }
937     
938     function stakeCatnipUni(uint256 amount) public updateStakingReward(msg.sender) {
939         catnipV2.safeTransferFrom(msg.sender, address(this), amount);
940         stakedBalances[msg.sender].catnipPoolTokens = stakedBalances[msg.sender].catnipPoolTokens.add(amount);
941         totalLiquidityStaked = totalLiquidityStaked.add(amount);                                                                              
942         emit catnipUniStaked(msg.sender, stakedBalances[msg.sender].catnipPoolTokens, totalLiquidityStaked);
943     }
944     
945     function withdrawCatnipUni(uint256 amount) public updateStakingReward(msg.sender) {
946         catnipV2.safeTransfer(msg.sender, amount);
947         stakedBalances[msg.sender].catnipPoolTokens = stakedBalances[msg.sender].catnipPoolTokens.sub(amount);
948         totalLiquidityStaked = totalLiquidityStaked.sub(amount);                                                                              
949         emit catnipUniWithdrawn(msg.sender, amount, totalLiquidityStaked);
950     }
951     
952     
953     
954     function stakeDarkNyanUni(uint256 amount) public updateStakingReward(msg.sender) {
955         darkNyanV2.safeTransferFrom(msg.sender, address(this), amount);
956         stakedBalances[msg.sender].darkNyanPoolTokens = stakedBalances[msg.sender].darkNyanPoolTokens.add(amount);
957         totalLiquidityStaked = totalLiquidityStaked.add(amount);                                                                              
958         emit darkNyanUniStaked(msg.sender, amount, totalLiquidityStaked);
959     }
960     
961     function withdrawDarkNyanUni(uint256 amount) public updateStakingReward(msg.sender) {
962         darkNyanV2.safeTransfer(msg.sender, amount);
963         stakedBalances[msg.sender].darkNyanPoolTokens = stakedBalances[msg.sender].darkNyanPoolTokens.sub(amount);
964         totalLiquidityStaked = totalLiquidityStaked.sub(amount);                                                                              
965         emit darkNyanUniWithdrawn(msg.sender, amount, totalLiquidityStaked);
966     }
967     
968     function getNipUniStakeAmount(address _account) public view returns (uint256) {
969         return stakedBalances[_account].catnipPoolTokens;
970     }
971     
972     function getDNyanUniStakeAmount(address _account) public view returns (uint256) {
973         return stakedBalances[_account].darkNyanPoolTokens;
974     }
975     
976     function myRewardsBalance(address _account) public view returns(uint256) {
977         uint256 liquidityBonus;
978         if (stakedBalances[_account].darkNyanPoolTokens > 0) {
979             liquidityBonus = stakedBalances[_account].darkNyanPoolTokens / liquidityMultiplier;
980         }
981         
982         if (block.number > stakedBalances[_account].lastBlockChecked) {
983             uint256 rewardBlocks = block.number
984                                         .sub(stakedBalances[_account].lastBlockChecked);
985                                         
986                                         
987              
988             if (stakedBalances[_account].catnipPoolTokens > 0) {
989                 return stakedBalances[_account].rewards
990                                                 .add(stakedBalances[_account].catnipPoolTokens)
991                                                 .add(liquidityBonus)
992                                                 .mul(rewardBlocks)
993                                                 / miningDifficulty;
994             } else {
995                 return 0;
996             }
997         }
998     }
999     
1000     function getReward() public updateStakingReward(msg.sender) {
1001         uint256 reward = stakedBalances[msg.sender].rewards;
1002        stakedBalances[msg.sender].rewards = 0;
1003        _mint(msg.sender, reward.mul(8) / 10);
1004        uint256 fundingPoolReward = reward.mul(2) / 10;
1005        _mint(address(this), fundingPoolReward);
1006        emit Rewards(msg.sender, reward);
1007     }
1008     
1009     function toggleFundsTransfer() public _onlyOwner {
1010         isSendingFunds = !isSendingFunds;
1011     }
1012     
1013     function sendDarkNyanToFund(uint256 amount) public {
1014         if (!isSendingFunds) {
1015             return;
1016         }
1017         lastBlockSent = block.number;
1018         IERC20(address(this)).safeTransfer(fundVotingAddress, amount);
1019         emit FundsSentToFundingAddress(msg.sender, amount);
1020     }
1021     
1022     
1023 }